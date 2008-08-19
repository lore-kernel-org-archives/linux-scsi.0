From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 15:04:37 +0200
Message-ID: <48AAC4E5.8000801@s5r6.in-berlin.de>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com> <48AAAFAC.9050502@s5r6.in-berlin.de> <20080819122738.GC21854@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080819122738.GC21854@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gwendal Grignou <gwendal@google.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Aug 19, 2008 at 01:34:04PM +0200, Stefan Richter wrote:
>> Could you make it configurable, so that people who don't need this
>> interface can build the kernel without it?
> 
> Please, no.  Don't we already have enough CONFIG options?

I agree that CONFIGurability should be minimal only as far as essential
functionality is concerned.  What is proposed here doesn't look
essential to me.  (Essential in order to support a broad range of
hardware or of usage scenarios, that is.)  Hence it should be off by
default, if it is added at all.
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/
