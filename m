From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 08:22:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071622.IAA29906@adam.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>I'd prefer to get rid of scsi_bus_match entirely.  But if we have to
>keep it having a side-effect free method ito the drivers is probably
>the right thing, yes.  I'd rather call it "math", though to a) show
>what it's used for and b) not fool people porting drivers from 2.4 to
>2.5.

I agree that renaming ->detect to ->match would be an improvement.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."
