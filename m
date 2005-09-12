From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Tue, 13 Sep 2005 01:51:36 +0200
Message-ID: <43261488.5040309@s5r6.in-berlin.de>
References: <1126308949.4799.54.camel@mulgrave> <20050910041218.29183.qmail@web51612.mail.yahoo.com> <20050911093847.GA5429@infradead.org> <20050912160805.GC32395@parisc-linux.org> <4325D1E8.9030302@adaptec.com> <20050912195521.GD32395@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932367AbVILXwY@vger.kernel.org>
In-Reply-To: <20050912195521.GD32395@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Luben Tuikov <luben_tuikov@adaptec.com>, Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Sep 12, 2005 at 03:07:20PM -0400, Luben Tuikov wrote:
>>No, my point is that SCSI Core "development" isn't following any
>>spec or document or any formally accepted spec.
> 
> That's right.  And it's actually a good thing.

Are you two discussing specs for scsi subsystem development process 
here, or are you discussing specs for scsi subsystem architecture?

In case of the latter: These are indispensable. The scope of the scsi 
subsystem is big enough to benefit from following the T10 specs, 
including their concepts, their layers. I am saying this as somebody who 
is trying to bring one small part of the subsystem forward, who will 
never be able to grasp what is going on throughout the whole subsystem 
nor to learn all about all SCSI layers. Thereby, every bigger or smaller 
layering violation, every common SCSI concept that I have trouble to 
match with Linux' scsi concepts will be a bigger or smaller setback for 
undertakings like mine. (Well, I'm stating the obvious, or so I hope.)
-- 
Stefan Richter
-=====-=-=-= =--= -==-=
http://arcgraph.de/sr/
