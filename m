From: margitsw@t-online.de (Margit Schubert-While)
Subject: 2.5.53 aic7xxx problems ?
Date: Fri, 27 Dec 2002 09:18:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20021227091703.00b558a0@pop.t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Following turns up in the log.
Cause for concern ?
HW is:
  Adaptec 39160 - 2 x U160 on channel A, 2 x U160 on channel B (Id's 0,1,2,3)
  Adaptec 2940AU - DVD + DAT (Id's 4,5)

Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 768 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): Handled Residual of 10 bytes
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: sr0: CDROM not ready.  Make sure there is a 
disc in the drive.
Dec 25 11:18:40 margit kernel: cdrom: open failed.
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 8 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 2: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 12 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 768 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:4:0): Handled Residual of 14 bytes
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): SCB 3: requests Check Status
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): Sending Sense
Dec 25 11:18:40 margit kernel: (scsi2:A:5:0): Handled Residual of 10 bytes
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:0:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi0:A:1:0): Handled Residual of 752 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (752 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:2:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error
Dec 25 11:18:40 margit kernel: (scsi1:A:3:0): Handled Residual of 748 bytes
Dec 25 11:18:40 margit kernel: Saw underflow (748 of 768 bytes). Treated as 
error

Merry Christmas all.
Margit 

