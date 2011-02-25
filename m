From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] megaraid_sas: some corrections in megasas_transition_to_ready
Date: Fri, 25 Feb 2011 14:37:54 -0800
Message-ID: <AANLkTikfiYnzUJ3w89KyVShWRNKR6gb0G7g240g=GGSP@mail.gmail.com>
References: <4D67D739.3020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61476 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab1BYWhz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2011 17:37:55 -0500
Received: by wwb22 with SMTP id 22so934507wwb.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 14:37:54 -0800 (PST)
In-Reply-To: <4D67D739.3020002@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Yang, Bo" <Bo.Yang@lsi.com>

On Fri, Feb 25, 2011 at 8:22 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> Hi,
>
> megasas_transition_to_ready seems to use some code which isn't needed.
> I removed some variables, I hope this makes the code easier thus better readable.
> max_wait - the assigned value is the same in al cases

Tomas,

Your patch removes the ability to easily assign different wait times
for each controller state.  Although we are currently using a maximum
of 180 seconds for all states, there is talk within LSI (at this very
moment) about altering how long we wait in each state.

-Adam
