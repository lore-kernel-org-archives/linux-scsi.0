From: Shanker Balan <shanu@exocore.com>
Subject: Re: Seagate Cheetah: Firmware, Bugs, Compatibility?
Date: Wed, 8 Jan 2003 13:45:13 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030108081513.GA1217@exocore.com>
References: <A5974D8E5F98D511BB910002A50A66470580D4F1@hdsmsx103.hd.intel.com> <Pine.LNX.4.44.0301072238580.3021-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301072238580.3021-100000@uplift.swm.pp.se>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>

Hello:

Mikael Abrahamsson wrote,
> If I have not had any of my problems in 2-3 weeks I'll email back it
> as a success report.

I am having problems flashing the drive. I get an "-2" error with
sgdskfl.

Error -2 is a "-2 means that the SCSI request returned a check condition
(sense error)" from the UserGuide.

I got a similar sense error while trying to flash using the Quantum supplied
"DL_scsi.exe" under DOS.

Andrew, any idea what might be the problem here? Also whats a "Servo
image"?

Here is paste from "sgdskfl" run:

Log file /var/log/sgdskfl.log is open, debug=0

Num Name [bus:ch:id:lun] Type Vendor   Device_Model     FW__ Serial#_
Servo___
0 /dev/sg0 [0:0:0:0] Disk  QUANTUM  ATLAS10K3_18_SCA 020W 34220894
1 /dev/sg1 [0:0:1:0] Disk  QUANTUM  ATLAS10K3_73_SCA 020W 34820965
2 /dev/sg2 [0:0:2:0] Disk  QUANTUM  ATLAS10K3_73_SCA 020W 34820635

Enter Selection ('d' to download, 'q' to quit) : d

Device Num (0 to 2) : 2
Selected 2: [0:2] QUANTUM ATLAS10K3_73_SCA020W34820635
Reading image file atlas10k.lod, size = 377167
No servo image
Device [2] is ready for download
Starting download process for 1 disk.
Downloading Firmware image to disk 2 Wed Jan  8 13:40:52 2003
Current sg_cmd_done_bh00:00: sense key Illegal Request
write_buffer: Check Condition Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)
sense error, key=05 asc=26 ascq=80 Illegal RequestInfo valid=0, Current
[2] Error -2 in writing buffer
Press ENTER to continue

-- Shanu
http://shankerbalan.com/
