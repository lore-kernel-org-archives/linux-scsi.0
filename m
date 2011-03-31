From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH, RFC 0/2] scic: remove pointless stuctures
Date: Thu, 31 Mar 2011 15:24:25 -0700
Message-ID: <AANLkTin-VOOBSwfoAFODWDMvjEjA0NV=x093qzyGAnpc@mail.gmail.com>
References: <20110328000754.GA28347@infradead.org>
	<20110328132046.GA497@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36498 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaWY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 18:24:27 -0400
Received: by fxm17 with SMTP id 17so2211627fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 15:24:25 -0700 (PDT)
In-Reply-To: <20110328132046.GA497@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Mon, Mar 28, 2011 at 6:20 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> Start killing off the pointless sci_base* structures which do nothing
> but causing a lot of unreadable code by converting forth and back
> between them and the real structures.
>
> I've done the sci_base_controller, and sci_base_request on a rainy
> sunday afternoon, but the port, phy and remote device also need the
> same treatment. =A0And after that the sci_base_object crap needs to
> go in favour of just using container_of or properly typed pointers.
>
> But I'll rather leave that to you Intel guys, spending more time
> on this codebase won't be good for my mental health.

Understood, but it's not everyday you get to submit patches that
consistently have a 2x deletions/insertions ratio.  In fact that has
been my rule of thumb for this driver for a while, any cleanup patch
that falls short of that ratio is probably too narrow of a cleanup.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
