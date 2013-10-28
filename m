From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Backporting 'libsas: fix timeout vs completion race' and related
 patches to 3.2.51 recommended?
Date: Mon, 28 Oct 2013 13:33:47 -0700
Message-ID: <CAA9_cmcwZypu7FYTN2GcbN1t1Q8p-VegAcuTr5mw=Nwrmq4LRA@mail.gmail.com>
References: <20131026004724.GA18880@amit-debian.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:39314 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3J1Uds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2013 16:33:48 -0400
Received: by mail-la0-f47.google.com with SMTP id ep20so5593936lab.6
        for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2013 13:33:47 -0700 (PDT)
In-Reply-To: <20131026004724.GA18880@amit-debian.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Amit Uttamchandani <auttamchandani@logicube.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Oct 25, 2013 at 5:47 PM, Amit Uttamchandani
<auttamchandani@logicube.com> wrote:
> Hello,
>
> Tested kernel 3.4.62, which introduces:
>
>  libsas error handling + discovery patch set
>
>  http://lwn.net/Articles/476986/
>
> Is it advisable for me to backport this to v3.2.51?
>

If you need reliable ata error handling via libsas then, yes.  Kernels
prior to 3.4 will encounter some bugs in this area.

--
Dan
