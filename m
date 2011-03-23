From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 4/6] isci: hardware / topology event handling
Date: Wed, 23 Mar 2011 01:15:08 -0700
Message-ID: <AANLkTi=dfZ5OtV0rY_y=9boMCAu_=47Bucz_-Jwu0d-6@mail.gmail.com>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
	<20110207003455.27040.94947.stgit@localhost6.localdomain6>
	<20110318161852.GA19008@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1CWIPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 04:15:10 -0400
Received: by fxm17 with SMTP id 17so7107396fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2011 01:15:09 -0700 (PDT)
In-Reply-To: <20110318161852.GA19008@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 18, 2011 at 9:18 AM, Christoph Hellwig <hch@infradead.org>
wrote:> On Sun, Feb 06, 2011 at 04:34:55PM -0800, Dan Williams wrote:
>> 2/ Timer interface.
>
> This just needs to go away. =A0It's just a bad emulation of
> Solaris/Windows style dynamically allocated timer lists, that just ma=
ke
> life harder for anyone trying to use it.

Yeah, started hacking at it [1], but it can all just be converted to
delayed work.

> Same for the whole events.c code, which is just pointless wrappers.

Ok.

--
Dan

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dcomm=
itdiff;h=3D8d32e5b2aefe0d5e966cc7f5c5e887aa2d2b6090;hp=3Ddb3dd417bed5b2=
be0c95ace9e4b8871102ca5dcf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
