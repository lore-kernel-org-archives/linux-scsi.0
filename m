From: Andi Kleen <ak@muc.de>
Subject: Re: 2.6.6 + Adaptec I2O
Date: 1 Jun 2004 22:29:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601202958.GA97294@colin2.muc.de>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5159@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:49668 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S265213AbUFAU37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 16:29:59 -0400
Date: Tue, 1 Jun 2004 22:29:58 +0200
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5159@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andi Kleen <ak@muc.de>, Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Tue, Jun 01, 2004 at 03:52:26PM -0400, Salyzyn, Mark wrote:
> The driver reports that if it is an x86_64, that it is an Intel based
> processor that is *not* an i686 driver. It replaces PROC_PENTIUM with
> PROC_SEXIUM. Isn't this what you want? Or is it the *name* of this bit
> that offends you?

No, not at all. I like that bit.

I'm just objecting to having a driver do such useless things,
especially when it used to #error when the system type is 
unknown.

(I remember having to fix that for some drivers early in the
x86-64 port and I certainly cursed the inventor of these things
at that time)

But I will shut up on this issue now.

-Andi
