From: Andries.Brouwer@cwi.nl
Subject: Re: [patch for playing] Patch to support 4000 disks and maintain backward compatibility
Date: Fri, 11 Apr 2003 20:07:24 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200304111807.h3BI7Or07403.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:59266 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261334AbTDKRzn (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2003 13:55:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com

    From James.Bottomley@SteelEye.com  Fri Apr 11 16:33:37 2003

    On Fri, 2003-04-11 at 06:42, Andries.Brouwer@cwi.nl wrote:
    >     Here is my problem..
    > 
    > OK, I see what you mean. I agree.

    Could you elaborate on the reason you want to keep the minor space
    compact?

That is not necessarily what I want.
Indeed, I see as one of the possible uses of a large dev_t
a hash of a proper name.

It is just that Badari and I were talking about the numbering scheme
index = next_index++ and he pointed out that the current system
has a certain weak number preservation guarantee that this
index = next_index++ does not have. True.

It is Roman who wanted to keep the number space compact.

It is me who wants compatibility as far as 8+8 device numbers are
concerned, while I can see lots of ways to use new number space.

(You need not worry that I worry about preservation of numbering
after rmmod. I am not interested. But in case anybody is, there
is a numbering solution that achieves that, too.)

The whole conversation came because there is an array in sd.c
that must go, or must be limited to the size needed for compatibility.

Andries
