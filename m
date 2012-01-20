From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Fri, 20 Jan 2012 15:28:51 -0800
Message-ID: <CABE8wwvK=uQx2cTK44Sn+79dj+MyGM1y4n7MoounkR7STHFkXQ@mail.gmail.com>
References: <4F19A981.4080502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:50900 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823Ab2ATX2w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2012 18:28:52 -0500
Received: by iabz7 with SMTP id z7so1561484iab.25
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jan 2012 15:28:51 -0800 (PST)
In-Reply-To: <4F19A981.4080502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tasleson@redhat.com
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Fri, Jan 20, 2012 at 9:50 AM, Tony Asleson <tasleson@redhat.com> wrote:
> I would like to give a brief background on the storage management API
> and library that I have been working on** and discuss the design and
> implementation challenges that I have encountered thus far.
>
> Most notable is the same topic Shyam Iyer brought up about proprietary
> plug-in support (http://marc.info/?l=linux-scsi&m=132454179114038&w=2).
> This very feature has influenced libStorageMgmt heavily and has raised a
> number of discussions on design and licensing.
>
> Discussion topics
> * Scope (What a storage library should/should not do)
> * Role (library position in management stack)
> * Features (specific: must have to would be nice)
> * Usage scenarios which highlight needed features
> * Licensing (most appropriate open source license)
> * Proprietary plug-in support

Interesting, how does this relate, or not relate, to udisks in device-kit?

--
Dan
