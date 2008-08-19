From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Tue, 19 Aug 2008 15:41:01 +0200
Message-ID: <48AACD6D.20001@s5r6.in-berlin.de>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com> <48AAAFAC.9050502@s5r6.in-berlin.de> <20080819122738.GC21854@parisc-linux.org> <48AAC7B0.9060107@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48AAC7B0.9060107@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gwendal Grignou <gwendal@google.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote:
>>> Gwendal Grignou wrote:
>>>> +	count = 0;
>>>> +	SETUP_PORT_ATTRIBUTE(nr_pmp_links);
>>>> +	SETUP_PORT_ATTRIBUTE(idle_irq);
>>>> +	BUG_ON(count > ATA_PORT_ATTRS);
>>>> +	i->port_attrs[count] = NULL;
> 
> I understand that such preprocessor games are hard to avoid in code like
> sysfs attribute setup.  I have nothing better to suggest, but they are
> ugly nevertheless, and may amount to bloat.
> 
> Anyway; the BUG_ON there should probably be a BUILD_BUG_ON.

...but alas gcc isn't clever enough:  It won't report if ATA_PORT_ATTRS 
was too small.
-- 
Stefan Richter
-=====-==--- =--- =--==
http://arcgraph.de/sr/
