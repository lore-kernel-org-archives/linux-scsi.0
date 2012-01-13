From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: mvsas with 3.1
Date: Fri, 13 Jan 2012 11:44:57 -0700
Message-ID: <201201131144.58044.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Is there chance this driver will ever be stable? After more than two years I'm 
starting to get extremely frustrated. I don't really have the option at the 
moment to get a new card, otherwise I would, likely a non marvell based 
device.

It actually managed to last 10 days this time though. Which is a record. The 
interesting thing is there are no warnings or errors in dmesg coming from the 
mvsas driver or scsi code. All that's happened is processes lock up when 
trying to write. Reading seems to be fine.

Just to refresh everyone's memory, it's a AOC-SASLP-MV8 card, has a 
MV64460/64461/64462 chipset. And I have 7 (seagate 7200.12 SATA drives hooked 
up).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
