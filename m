From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Cbe-oss-dev] LIO Target iSCSI/SE PS3-Linux / FC8 builds
Date: Tue, 5 Feb 2008 08:14:37 +0100
Message-ID: <e2e108260802042314p572909f3se1f58016cc20df14@mail.gmail.com>
References: <1202134623.11265.524.camel@haakon2.linux-iscsi.org>
	 <200802041647.06234.marc.dietrich@ap.physik.uni-giessen.de>
	 <1202140360.11265.543.camel@haakon2.linux-iscsi.org>
	 <200802041744.55909.marc.dietrich@ap.physik.uni-giessen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:40198 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYBEHOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:14:41 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2840042wxd.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 23:14:38 -0800 (PST)
In-Reply-To: <200802041744.55909.marc.dietrich@ap.physik.uni-giessen.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>, cbe-oss-dev@ozlabs.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Open iSCSI <open-iscsi@googlegroups.com>

On Feb 4, 2008 5:44 PM, Marc Dietrich
<Marc.Dietrich@ap.physik.uni-giessen.de> wrote:
> ...
> Anyway, heres a quick ugly fix for the ARCH detection code, tested on ps3.
> ...

Architecture detection is indeed broken in LIO. Would it be possible
to use the standard config.guess script instead of the custom LIO arch
detection script ? config.guess is included with a.o. automake and
libtool.

Bart Van Assche.
