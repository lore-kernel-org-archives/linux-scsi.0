From: "John Treubig" <jtreubig@hotmail.com>
Subject: Controlling PATA access speeds
Date: Thu, 01 Jun 2006 12:25:45 -0500
Message-ID: <BAY113-F9629AB1FA5713C03D4F42DF900@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We are currently using Promise Ultra133 TX2 (PDC20269 chip; pata_pdc2027x 
driver, kernel version 2.6.15) to test and access PATA drives.   If my 
understanding is correct, during boot, a drive is queryied to determine it's 
maximum access speed and the driver sets the access speed to be no higher 
than the drive can handle.  This is not speed testing the drive, but just 
the drive firmware reporting it's maximum designed transfer rate.  Due to 
design constraints of the cabling to the drives, we need to force the access 
speed lower than what the Drive reponds.  Is there a mechanism to tell the 
driver/LibATA to set the access speed to go no higher than a value I supply? 
  This can be a static setting that is set at boot, as it does not need to 
be a dynamic setting.

Best wishes,
John Treubig
VT Miltope Corporation


