From: William Lee Irwin III <wli@holomorphy.com>
Subject: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Sun, 12 Jan 2003 23:15:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113071543.GA9558@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gibbs@scsiguy.com

SCSI CD burning appears to fail, causing audio CD's burned with
bash-2.05# cdrecord -v -pad speed=1 dev=0,3,0 -audio `cat tracks`
(where the tracks are wav files) to have massive numbers of skips.

$ cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: WDIGTL   Model: WDE18310 ULTRA2  Rev: 1.30
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: YAMAHA   Model: CRW8424S         Rev: 1.0j
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: IBM      Model: DDYS-T36950N     Rev: S93E
  Type:   Direct-Access                    ANSI SCSI revision: 03

The adapter is an Adaptec 39160, kernel is 2.5.49-mm2.

It works in 2.4, of course.


Bill
