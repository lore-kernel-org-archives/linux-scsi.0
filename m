From: JiSheng Zhang <jszhang3@gmail.com>
Subject: Is there any elegant way to re-identify and re-configure xfer mode
Date: Tue, 1 Nov 2011 14:27:16 +0800
Message-ID: <CADyp2PdXeq8phoWSntyjGSY7dc93kcRg9DRV6cdCWi96j5g2LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi List,

I need your help. I'm developing driver for one specific cdrom:

I need to send firmware to the "basic mode" cdrom via ATA bus, then
then cdrom will be under "working mode".

The problem is the model, vendor and xfer mode etc is changed also, I
need to re-identify and re-configure it.
I did these by manually call
ata_scsi_find_dev()=>ata_dev_read_id()=>ata_dev_configure()=>ata_set_mode()

Is there any elegant way to handle such situation?

Thanks very much,
Jisheng
