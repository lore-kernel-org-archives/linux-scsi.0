From: George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Thu, 22 Dec 2016 15:43:42 +0530
Message-ID: <1dce5bf8-b50f-0edf-8ce9-ccfc3cfa70b3@caviumnetworks.com>
References: <585A69E6.6040009@caviumnetworks.com>
 <1482320547.7638.7.camel@suse.com> <585A7073.3060904@caviumnetworks.com>
 <931b00cf-e273-6d07-8a99-71916376af67@redhat.com>
 <585A79F5.7080701@caviumnetworks.com> <1482331185.7638.14.camel@suse.com>
 <98b66992-826f-7073-2a1d-eee6a2a9590f@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <98b66992-826f-7073-2a1d-eee6a2a9590f-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: George.Cherian-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

dmesg with the patch applied

[root@localhost ~]# dmesg
[  108.575683] usb 4-1.3: new SuperSpeed USB device number 3 using xhci_hcd
[  108.596485] usb 4-1.3: New USB device found, idVendor=152d, 
idProduct=9561
[  108.603350] usb 4-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=5
[  108.610663] usb 4-1.3: Product: JMS56x Series
[  108.615009] usb 4-1.3: Manufacturer: JMicron
[  108.619277] usb 4-1.3: SerialNumber: 00000000000000000000
[  109.790747] usbcore: registered new interface driver usb-storage
[  110.061769] scsi host4: scsi_eh_4: sleeping
[  110.062119] scsi host4: uas
[  110.062305] usbcore: registered new interface driver uas
[  110.062370] scsi 4:0:0:0: Send: scmd 0xffff801fddcc1500
[  110.062374] scsi 4:0:0:0: CDB: Inquiry 12 00 00 00 24 00
[  110.062551] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.062555] scsi 4:0:0:0: CDB: Inquiry 12 00 00 00 24 00
[  110.062559] scsi 4:0:0:0: 0 sectors total, 36 bytes done.
[  110.062615] scsi 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.062618] scsi 4:0:0:0: CDB: Inquiry 12 00 00 00 60 00
[  110.062790] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.062793] scsi 4:0:0:0: CDB: Inquiry 12 00 00 00 60 00
[  110.062797] scsi 4:0:0:0: 0 sectors total, 96 bytes done.
[  110.062829] scsi 4:0:0:0: Direct-Access     ST4000NM 0033-9ZM170      
0001 PQ: 0 ANSI: 6
[  110.062844] scsi 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.062847] scsi 4:0:0:0: CDB: Inquiry 12 01 00 00 ff 00
[  110.063011] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.063014] scsi 4:0:0:0: CDB: Inquiry 12 01 00 00 ff 00
[  110.063018] scsi 4:0:0:0: 0 sectors total, 255 bytes done.
[  110.063045] scsi 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.063048] scsi 4:0:0:0: CDB: Inquiry 12 01 80 00 ff 00
[  110.063216] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.063219] scsi 4:0:0:0: CDB: Inquiry 12 01 80 00 ff 00
[  110.063222] scsi 4:0:0:0: 0 sectors total, 255 bytes done.
[  110.063248] scsi 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.063251] scsi 4:0:0:0: CDB: Inquiry 12 01 83 00 ff 00
[  110.063428] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.063431] scsi 4:0:0:0: CDB: Inquiry 12 01 83 00 ff 00
[  110.063435] scsi 4:0:0:0: 0 sectors total, 255 bytes done.
[  110.063463] scsi 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.063466] scsi 4:0:0:0: CDB: Report luns a0 00 00 00 00 00 00 00 10 
00 00 00
[  110.063626] scsi 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.063629] scsi 4:0:0:0: CDB: Report luns a0 00 00 00 00 00 00 00 10 
00 00 00
[  110.063633] scsi 4:0:0:0: 8 sectors total, 4096 bytes done.
[  110.063912] sd 4:0:0:0: Send: scmd 0xffff801fdd8e5880
[  110.063916] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.064018] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.064021] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.064026] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.064050] sd 4:0:0:0: Send: scmd 0xffff801fdd8e5a00
[  110.064053] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.064064] sd 4:0:0:0: Attached scsi generic sg1 type 0
[  110.064209] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.064213] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.064216] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.064240] sd 4:0:0:0: [sdb] 7814037168 512-byte logical blocks: 
(4.00 TB/3.63 TiB)
[  110.064253] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.064256] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.064421] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.064424] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.064427] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.064454] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.064457] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.064625] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.064628] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.064632] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.064658] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.064661] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.064829] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.064832] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.064836] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.064861] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.064864] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.065030] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.065033] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.065037] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.065064] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.065067] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.065251] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.065254] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.065257] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.065275] sd 4:0:0:0: [sdb] Write Protect is off
[  110.065279] sd 4:0:0:0: [sdb] Mode Sense: 67 00 10 08
[  110.065291] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.065294] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.065484] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.065487] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.065490] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.065517] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.065520] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.065698] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.065701] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.065705] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.065724] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[  110.065736] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.065739] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.065902] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.065905] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.065909] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.066134] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.066138] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.066226] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.066229] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.066233] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.066257] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.066261] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.066413] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.066416] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.066420] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.066448] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.066452] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.066614] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.066617] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.066620] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.066646] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.066649] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.066833] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.066836] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.066839] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.066865] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.066868] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.067032] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.067035] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.067039] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.067065] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.067068] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.067234] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.067237] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.067241] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.067267] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.067270] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.067456] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.067459] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.067462] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.067488] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.067491] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.067669] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.067672] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.067676] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.067702] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.067705] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.067883] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.067886] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.067889] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.067915] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.067918] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.068081] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.068084] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.068088] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.068138] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=0, count=16
[  110.068141] sd 4:0:0:0: [sdb] block=0
[  110.068144] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.068148] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338880
[  110.068152] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 10 00 00
[  110.068170] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=16, 
count=16
[  110.068173] sd 4:0:0:0: [sdb] block=16
[  110.068176] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.077468] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.077471] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 10 00 00
[  110.077476] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.077479] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.077496] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.077500] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 10 00 00 00 10 00 00
[  110.077516] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=32, 
count=16
[  110.077519] sd 4:0:0:0: [sdb] block=32
[  110.077522] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.077789] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.077793] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 10 00 00 00 10 00 00
[  110.077797] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.077800] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.077811] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338880
[  110.077814] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 20 00 00 00 10 00 00
[  110.077830] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=48, 
count=16
[  110.077833] sd 4:0:0:0: [sdb] block=48
[  110.077836] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.078131] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.078135] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 20 00 00 00 10 00 00
[  110.078139] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.078142] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.078151] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.078154] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 30 00 00 00 10 00 00
[  110.078169] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=64, 
count=16
[  110.078171] sd 4:0:0:0: [sdb] block=64
[  110.078174] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.078459] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.078462] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 30 00 00 00 10 00 00
[  110.078466] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.078469] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.078478] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338880
[  110.078481] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 40 00 00 00 10 00 00
[  110.078495] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=80, 
count=16
[  110.078498] sd 4:0:0:0: [sdb] block=80
[  110.078501] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.078625] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.078629] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 40 00 00 00 10 00 00
[  110.078632] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.078635] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.078644] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.078648] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 50 00 00 00 10 00 00
[  110.078661] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=96, 
count=16
[  110.078664] sd 4:0:0:0: [sdb] block=96
[  110.078667] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.078778] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.078782] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 50 00 00 00 10 00 00
[  110.078785] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.078788] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.078797] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338880
[  110.078800] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 60 00 00 00 10 00 00
[  110.078814] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=112, 
count=16
[  110.078817] sd 4:0:0:0: [sdb] block=112
[  110.078820] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.078928] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.078931] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 60 00 00 00 10 00 00
[  110.078935] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.078938] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.078947] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.078950] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 70 00 00 00 10 00 00
[  110.079078] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.079082] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 70 00 00 00 10 00 00
[  110.079085] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.079088] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.079180] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814037120, count=16
[  110.079183] sd 4:0:0:0: [sdb] block=7814037120
[  110.079186] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.079190] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.079194] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 80 00 00 00 10 00 00
[  110.079212] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814037136, count=16
[  110.079214] sd 4:0:0:0: [sdb] block=7814037136
[  110.079217] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.097427] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.097431] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 80 00 00 00 10 00 00
[  110.097435] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.097438] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.097449] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338880
[  110.097452] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 90 00 00 00 10 00 00
[  110.097468] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814037152, count=16
[  110.097471] sd 4:0:0:0: [sdb] block=7814037152
[  110.097474] sd 4:0:0:0: [sdb] reading 16/16 512 byte blocks.
[  110.097750] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.097753] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 90 00 00 00 10 00 00
[  110.097757] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.097760] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.097770] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.097773] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be a0 00 00 00 10 00 00
[  110.105939] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.105942] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be a0 00 00 00 10 00 00
[  110.105946] sd 4:0:0:0: [sdb] sd_done: completed 8192 of 8192 bytes
[  110.105949] sd 4:0:0:0: [sdb] 16 sectors total, 8192 bytes done.
[  110.106025]  sdb: sdb1
[  110.106322] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.106325] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.106419] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.106423] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.106426] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.106435] sd 4:0:0:0: Send: scmd 0xffff801fcc338880
[  110.106438] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.106527] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.106530] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.106534] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.106542] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.106545] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.106694] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.106698] sd 4:0:0:0: CDB: Read capacity(16) 9e 10 00 00 00 00 00 
00 00 00 00 00 00 20 00 00
[  110.106701] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.106728] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.106732] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.106892] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.106896] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.106899] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.106923] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.106926] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.107107] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.107110] sd 4:0:0:0: CDB: Inquiry 12 01 b0 00 40 00
[  110.107113] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.107138] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.107141] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.107305] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.107308] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.107311] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.107335] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.107338] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.107503] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.107506] sd 4:0:0:0: CDB: Inquiry 12 01 b1 00 40 00
[  110.107509] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.107534] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.107537] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.107732] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.107735] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 3f 00 04 00
[  110.107738] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.107763] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.107766] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.107943] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.107946] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 04 00
[  110.107949] sd 4:0:0:0: 0 sectors total, 4 bytes done.
[  110.107974] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.107976] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.108154] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.108156] sd 4:0:0:0: CDB: Mode Sense(6) 1a 00 08 00 20 00
[  110.108160] sd 4:0:0:0: 0 sectors total, 32 bytes done.
[  110.108184] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.108187] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.108357] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.108360] sd 4:0:0:0: CDB: Inquiry 12 01 00 00 40 00
[  110.108363] sd 4:0:0:0: 0 sectors total, 64 bytes done.
[  110.108380] sd 4:0:0:0: [sdb] Attached SCSI disk
[  110.120479] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
[  110.120486] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
[  110.120504] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fddcc1680
[  110.120508] sd 4:0:0:0: [sdb] CDB: Inquiry 12 00 00 00 24 00
[  110.120685] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.120688] sd 4:0:0:0: [sdb] CDB: Inquiry 12 00 00 00 24 00
[  110.120692] sd 4:0:0:0: [sdb] 0 sectors total, 36 bytes done.
[  110.120719] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
[  110.120724] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x2285
[  110.120739] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.120742] sd 4:0:0:0: [sdb] CDB: ATA command pass through(12)/Blank 
a1 08 2e 00 01 00 00 00 00 ec 00 00
[  110.120760] sd 4:0:0:0: [sdb] Done: SUCCESS Result: 
hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK
[  110.120763] sd 4:0:0:0: [sdb] CDB: ATA command pass through(12)/Blank 
a1 08 2e 00 01 00 00 00 00 ec 00 00
[  110.120768] sd 4:0:0:0: [sdb] Sense Key : Illegal Request [current]
[  110.120774] sd 4:0:0:0: [sdb] Add. Sense: Invalid field in cdb
[  110.120778] sd 4:0:0:0: [sdb] 1 sectors total, 512 bytes done.
[  110.120806] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x30d
[  110.120832] sd 4:0:0:0: Send: scmd 0xffff801fcf9e6180
[  110.120835] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.120947] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.120951] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.120954] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.122574] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x5331
[  110.122615] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036992, count=128
[  110.122618] sd 4:0:0:0: [sdb] block=7814036992
[  110.122622] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.122626] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fd91a0480
[  110.122630] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 00 00 00 00 80 00 00
[  110.123813] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.123817] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 00 00 00 00 80 00 00
[  110.123821] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.123824] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.123876] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814037120, count=48
[  110.123879] sd 4:0:0:0: [sdb] block=7814037120
[  110.123882] sd 4:0:0:0: [sdb] reading 48/48 512 byte blocks.
[  110.123886] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.123890] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 80 00 00 00 30 00 00
[  110.124162] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.124165] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
be 80 00 00 00 30 00 00
[  110.124169] sd 4:0:0:0: [sdb] sd_done: completed 24576 of 24576 bytes
[  110.124173] sd 4:0:0:0: [sdb] 48 sectors total, 24576 bytes done.
[  110.124216] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=0, 
count=128
[  110.124219] sd 4:0:0:0: [sdb] block=0
[  110.124222] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.124226] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.124230] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 80 00 00
[  110.124560] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.124563] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 80 00 00
[  110.124567] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.124570] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.124622] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036864, count=128
[  110.124624] sd 4:0:0:0: [sdb] block=7814036864
[  110.124628] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.124632] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.124636] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bd 80 00 00 00 80 00 00
[  110.124987] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.124990] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bd 80 00 00 00 80 00 00
[  110.124994] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.124998] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.125060] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036736, count=128
[  110.125063] sd 4:0:0:0: [sdb] block=7814036736
[  110.125066] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.125071] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.125074] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bd 00 00 00 00 80 00 00
[  110.129185] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.129189] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bd 00 00 00 00 80 00 00
[  110.129193] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.129197] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.129242] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036480, count=128
[  110.129245] sd 4:0:0:0: [sdb] block=7814036480
[  110.129248] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.129252] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.129256] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bc 00 00 00 00 80 00 00
[  110.130064] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.130068] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bc 00 00 00 00 80 00 00
[  110.130072] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.130075] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.130120] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036352, count=128
[  110.130123] sd 4:0:0:0: [sdb] block=7814036352
[  110.130127] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.130131] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.130135] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bb 80 00 00 00 80 00 00
[  110.135047] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.135050] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bb 80 00 00 00 80 00 00
[  110.135054] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.135057] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.135100] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036224, count=128
[  110.135103] sd 4:0:0:0: [sdb] block=7814036224
[  110.135106] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.135110] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.135114] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bb 00 00 00 00 80 00 00
[  110.136011] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.136015] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
bb 00 00 00 00 80 00 00
[  110.136019] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.136022] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.136067] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814036096, count=128
[  110.136069] sd 4:0:0:0: [sdb] block=7814036096
[  110.136073] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.136077] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.136081] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
ba 80 00 00 00 80 00 00
[  110.136473] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.136476] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
ba 80 00 00 00 80 00 00
[  110.136480] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.136483] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.136531] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814034048, count=128
[  110.136534] sd 4:0:0:0: [sdb] block=7814034048
[  110.136537] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.136541] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.136545] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b2 80 00 00 00 80 00 00
[  110.138254] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.138258] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b2 80 00 00 00 80 00 00
[  110.138262] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.138265] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.138332] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=2048, 
count=128
[  110.138335] sd 4:0:0:0: [sdb] block=2048
[  110.138338] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.138342] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.138346] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
08 00 00 00 00 80 00 00
[  110.158084] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.158088] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
08 00 00 00 00 80 00 00
[  110.158092] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.158095] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.158222] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=128, 
count=384
[  110.158224] sd 4:0:0:0: [sdb] block=128
[  110.158228] sd 4:0:0:0: [sdb] reading 384/384 512 byte blocks.
[  110.158232] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.158236] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 80 00 00 01 80 00 00
[  110.158956] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.158959] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 80 00 00 01 80 00 00
[  110.158964] sd 4:0:0:0: [sdb] sd_done: completed 196608 of 196608 bytes
[  110.158967] sd 4:0:0:0: [sdb] 384 sectors total, 196608 bytes done.
[  110.159136] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=768, 
count=128
[  110.159139] sd 4:0:0:0: [sdb] block=768
[  110.159142] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.159146] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.159150] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
03 00 00 00 00 80 00 00
[  110.159626] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.159630] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
03 00 00 00 00 80 00 00
[  110.159634] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.159637] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.159712] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=896, 
count=128
[  110.159715] sd 4:0:0:0: [sdb] block=896
[  110.159719] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.159723] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.159727] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
03 80 00 00 00 80 00 00
[  110.160087] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.160090] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
03 80 00 00 00 80 00 00
[  110.160094] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.160097] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.160176] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=512, 
count=128
[  110.160179] sd 4:0:0:0: [sdb] block=512
[  110.160182] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.160187] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.160190] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
02 00 00 00 00 80 00 00
[  110.160622] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.160626] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
02 00 00 00 00 80 00 00
[  110.160630] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.160633] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.160688] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=4096, 
count=128
[  110.160691] sd 4:0:0:0: [sdb] block=4096
[  110.160694] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.160699] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.160702] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
10 00 00 00 00 80 00 00
[  110.163701] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.163704] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
10 00 00 00 00 80 00 00
[  110.163708] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.163711] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.164996] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.165000] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.165091] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.165095] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.165098] sd 4:0:0:0: 0 sectors total, 0 bytes done.
[  110.166532] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814035328, count=128
[  110.166535] sd 4:0:0:0: [sdb] block=7814035328
[  110.166539] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.166543] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fdccdf000
[  110.166547] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b7 80 00 00 00 80 00 00
[  110.187509] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.187512] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b7 80 00 00 00 80 00 00
[  110.187517] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.187520] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.187575] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78139392, count=128
[  110.187578] sd 4:0:0:0: [sdb] block=78139392
[  110.187581] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.187586] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.187590] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
50 00 00 00 00 80 00 00
[  110.205051] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.205055] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
50 00 00 00 00 80 00 00
[  110.205059] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.205062] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.205115] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=7814035072, count=128
[  110.205118] sd 4:0:0:0: [sdb] block=7814035072
[  110.205121] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.205126] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.205129] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b6 80 00 00 00 80 00 00
[  110.227429] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.227432] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 01 d1 c0 
b6 80 00 00 00 80 00 00
[  110.227436] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.227440] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.227511] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78141440, count=128
[  110.227514] sd 4:0:0:0: [sdb] block=78141440
[  110.227517] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.227521] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.227525] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
58 00 00 00 00 80 00 00
[  110.243636] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.243640] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
58 00 00 00 00 80 00 00
[  110.243644] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.243647] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.243762] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78139520, count=384
[  110.243764] sd 4:0:0:0: [sdb] block=78139520
[  110.243768] sd 4:0:0:0: [sdb] reading 384/384 512 byte blocks.
[  110.243772] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.243776] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
50 80 00 00 01 80 00 00
[  110.247695] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.247699] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
50 80 00 00 01 80 00 00
[  110.247703] sd 4:0:0:0: [sdb] sd_done: completed 196608 of 196608 bytes
[  110.247706] sd 4:0:0:0: [sdb] 384 sectors total, 196608 bytes done.
[  110.247985] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78140160, count=128
[  110.247988] sd 4:0:0:0: [sdb] block=78140160
[  110.247992] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.247996] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.248000] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
53 00 00 00 00 80 00 00
[  110.248680] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.248684] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
53 00 00 00 00 80 00 00
[  110.248688] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.248691] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.248769] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78140288, count=128
[  110.248772] sd 4:0:0:0: [sdb] block=78140288
[  110.248775] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.248779] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.248783] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
53 80 00 00 00 80 00 00
[  110.249191] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.249194] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
53 80 00 00 00 80 00 00
[  110.249198] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.249202] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.249285] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78139904, count=128
[  110.249288] sd 4:0:0:0: [sdb] block=78139904
[  110.249291] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.249296] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.249299] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
52 00 00 00 00 80 00 00
[  110.249708] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.249712] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
52 00 00 00 00 80 00 00
[  110.249716] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.249719] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.249771] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: 
block=78143488, count=128
[  110.249774] sd 4:0:0:0: [sdb] block=78143488
[  110.249778] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.249782] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.249786] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
60 00 00 00 00 80 00 00
[  110.257495] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.257499] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 04 a8 
60 00 00 00 00 80 00 00
[  110.257503] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.257506] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.257727] sd 4:0:0:0: [sdb] sd_ioctl: disk=sdb, cmd=0x5331
[  110.257759] sd 4:0:0:0: [sdb] sd_setup_read_write_cmnd: block=0, 
count=128
[  110.257762] sd 4:0:0:0: [sdb] block=0
[  110.257765] sd 4:0:0:0: [sdb] reading 128/128 512 byte blocks.
[  110.257770] sd 4:0:0:0: [sdb] Send: scmd 0xffff801fcc338a00
[  110.257773] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 80 00 00
[  110.258168] sd 4:0:0:0: [sdb] Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.258171] sd 4:0:0:0: [sdb] CDB: Read(16) 88 00 00 00 00 00 00 00 
00 00 00 00 00 80 00 00
[  110.258175] sd 4:0:0:0: [sdb] sd_done: completed 65536 of 65536 bytes
[  110.258179] sd 4:0:0:0: [sdb] 128 sectors total, 65536 bytes done.
[  110.259759] sd 4:0:0:0: Send: scmd 0xffff801fcc338a00
[  110.259763] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.259854] sd 4:0:0:0: Done: SUCCESS Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK
[  110.259858] sd 4:0:0:0: CDB: Test Unit Ready 00 00 00 00 00 00
[  110.259861] sd 4:0:0:0: 0 sectors total, 0 bytes done.
=========================Connect end ====================================

===========================Disconnect log =================================

[  358.581289] scsi host4: uas_post_reset: alloc streams error -19 after 
reset
[  358.588962] sd 4:0:0:0: [sdb] Synchronizing SCSI cache
=====================================================================


On Thursday 22 December 2016 07:34 AM, George Cherian wrote:
> Hi Oliver,
>
> I will try it out and update you!!
>
>
> Regards,
>
> -George
>
> On Wednesday 21 December 2016 08:09 PM, Oliver Neukum wrote:
>> On Wed, 2016-12-21 at 18:17 +0530, George Cherian wrote:
>>> [  843.149653] scsi host5: uas_post_reset: alloc streams error -19
>>> after
>>> reset
>> That would mean the endpoints are gone. Which is odd.
>>
>>> [  843.157268] sd 5:0:0:0: [sdb] Synchronizing SCSI cache
>> Could you try the attached patch and do a SCSI log of the enumeration?
>>
>>     Regards
>>         Oliver
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
