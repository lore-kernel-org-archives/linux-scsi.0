From: Linux Explorer <erforschen_linux@yahoo.com>
Subject: SCSI vs IDE
Date: Mon, 30 Aug 2004 22:01:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040831050117.80689.qmail@web53204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-2023363624-1093928477=:79433"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web53204.mail.yahoo.com ([206.190.39.220]:45153 "HELO
	web53204.mail.yahoo.com") by vger.kernel.org with SMTP
	id S266595AbUHaFjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 01:39:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--0-2023363624-1093928477=:79433
Content-Type: text/plain; charset=us-ascii
Content-Id: 
Content-Disposition: inline

Hi,

I am using SCSI disk for backup operation, and I found
out that it takes long time than IDE disk.

Herewith I attach the two text files they give the
time taken for SCSI and IDE disks for writing 4728MB
of data using dd command.

Can anyone tell me , why SCSI disk takes approximately
3 times as IDE disk?

Herewith I attach one more text file inq.txt which
gives the Inquiry information of the attached scsi
disk.

I have tried this with adaptec and LSI logic scsi
controllers, both are taking same time.

Thanks in adavance.

Regards,
Linux Erfroschen

=====
Thanks and Regards,
Erforschen


		
__________________________________
Do you Yahoo!?
New and Improved Yahoo! Mail - Send 10MB messages!
http://promotions.yahoo.com/new_mail 
--0-2023363624-1093928477=:79433
Content-Type: text/plain; name="ide.txt"
Content-Description: ide.txt
Content-Disposition: inline; filename="ide.txt"

[root@localhost root]# time dd of=/dev/hda4 if=/dev/zero bs=1024k count=4728
4728+0 records in
4728+0 records out

real	2m24.942s
user	0m0.010s
sys	0m11.200s

--0-2023363624-1093928477=:79433
Content-Type: text/plain; name="scsi.txt"
Content-Description: scsi.txt
Content-Disposition: inline; filename="scsi.txt"

[root@localhost root]# time dd of=/dev/sda if=/dev/zero bs=1024k count=4728 
4728+0 records in
4728+0 records out

real	6m54.500s
user	0m0.000s
sys	0m12.100s

[root@localhost root]# raw /dev/raw/raw1 /dev/sda
/dev/raw/raw1:	bound to major 8, minor 0

[root@localhost root]# time dd of=/dev/raw/raw1 if=/dev/zero bs=1024k count=4728
4728+0 records in
4728+0 records out

real	6m47.032s
user	0m0.010s
sys	0m6.160s

--0-2023363624-1093928477=:79433
Content-Type: text/plain; name="inq.txt"
Content-Description: inq.txt
Content-Disposition: inline; filename="inq.txt"

scu> 
Inquiry Information:

                Peripheral Device Type: 0 (Direct Access)
                  Peripheral Qualifier: 0 (Peripheral Device Connected)
                  Device Type Modifier: 0
                       Removable Media: No
                          ANSI Version: 2 (Complies to ANSI X3.131-1994, SCSI-2)
                          ECMA Version: 0
                           ISO Version: 0
                  Response Data Format: 2 (SCSI-2)
                 Terminate I/O Process: No
                     Additional Length: 159
                    Soft Reset Support: No
               Command Queuing Support: Yes
               Target Transfer Disable: No
                Linked Command Support: Yes
            Synchronous Data Transfers: Yes
          Support for 16 Bit Transfers: Yes
          Support for 32 Bit Transfers: No
           Relative Addressing Support: No
                 Vendor Identification: DEC     
                Product Identification: RZ1EF-CB (C) DEC
               Firmware Revision Level: 0372
                  Vendor Specific Data: 36 38 30 30 46 39 43 31 "6800F9C1"
                                        34 4b 4d 53 42 44 43 33 "4KMSBDC3"
                                        37 32 20 20 00 00 00 00 "72      "
                                        00 00 00 00 00 00 00 00 "        "
                                        00 00 00 00 00 00 00 00 "        "
                                        00 00 00 00 00 00 00 00 "        "
                                        00 00 00 00 00 00 00 00 "        "
                                        00 00 00 00 00 00 30 39 "      09"
                                        52 49 39 38 32 37 31 00 "RI98271 "
                                        30 30 30 31 32 32 30 38 "00012208"
                                        4c 39 34 38 36 20 20 20 "L9486   "
                                        20 20 46 32 32 38 30 32 "  F22802"
                                        20 20 20 20 51 35 39 48 "    Q59H"
                                        37 31 35 32 4d 30 32 00 "7152M02 "
                                        45 33 32 32 38 30 20 20 "E32280  "
                                        20 20 31 39 39 38 00 00 "  1998  "


scu> 

--0-2023363624-1093928477=:79433--
