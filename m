Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B10C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 18:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FF260C4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 18:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhJLSSm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 14:18:42 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:55280 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbhJLSSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 14:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1634062598;
        bh=kYVXbhSu+3xlWV0F+z0ZmqFl5SQbQOpKKQ1LolCSn78=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=O75k6Z+IzX3Zhhon/SJIAAVi6XGNuZ3YaN1ifxjiy3+x09undrFb9DSi2oIn4r/Xb
         zXZU0sXapZ6730s3UhPp4l71Iu1OWSyuKAnvYuNAKxJRJDBlcuGHbTYlZVUyivsrj/
         WsrAsmFXI+6RlZ/CTIa1nzvGxf/d3EQzh711lzOA=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 24FA61280144;
        Tue, 12 Oct 2021 11:16:38 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MagZVEqcbCSc; Tue, 12 Oct 2021 11:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1634062597;
        bh=kYVXbhSu+3xlWV0F+z0ZmqFl5SQbQOpKKQ1LolCSn78=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=SD3PcYBPa/wR+BJo+blRCDx7dYa2lj5f9cZOijqHWxx5/2KV/4IwczBMSJP32Za1I
         NuXm0OBAxV9dVVFcAOojVMHMHNwhB3v/FfWC+DJj/8p07/oFMjgh9RPIIwC5dxJahZ
         vFeDwxz83Csi/2hF4x8VoHy5Pt+QKKCVtkUzFEyw=
Received: from jarvis.lan (c-67-166-170-96.hsd1.va.comcast.net [67.166.170.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 661A41280127;
        Tue, 12 Oct 2021 11:16:37 -0700 (PDT)
Message-ID: <9bec96ca5895fb4187666b401a288ae12a9156c5.camel@HansenPartnership.com>
Subject: Re: Meeting about the UFS driver
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Tue, 12 Oct 2021 14:16:36 -0400
In-Reply-To: <bb051910-43cd-9007-9267-3579765137cb@acm.org>
References: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
         <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
         <bb051910-43cd-9007-9267-3579765137cb@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-12 at 11:05 -0700, Bart Van Assche wrote:
> On 10/12/21 10:42 AM, James Bottomley wrote:
> > On Tue, 2021-10-12 at 10:29 -0700, Bart Van Assche wrote:
> > > A meeting will be held later this month to talk about the
> > > technical aspects of the UFS driver and also about how to evolve
> > > the UFS driver further. Since using email to coordinate a date,
> > > time and agenda is inconvenient, please use the following
> > > document to reach agreement about the time of the meeting and
> > > also about the agenda:
> > > 
> > > https://docs.google.com/document/d/1pYONI__pbNcVVQqPA7iSbeQRyf0IQOuZlYR7Gnrikco/
> > 
> > That link is giving permission denied.  You need to update the
> > sharing settings to give you an access link for anyone to view.
> 
> Hi James,
> 
> That document has been created using my work account. Recently my 
> employer changed the settings for work documents such that even 
> read-only access has to be granted explicitly. Making a document 
> viewable without authentication is no longer supported. I am
> considering next time I use Google Docs to prepare a meeting to use
> my personal gmail account since making documents public from a
> personal account is still supported.
> 
> The procedure to get access to this document is as follows:
> * Log in to an account with which a Google password has been
> associated.
> * Open the above link. The following text will appear: "You need
> access.  Ask for access, or switch to an account with access. Learn
> more. [Request access]".
> * Select the [Request access] button.

It's a bit proprietary for an open collaboration.  If it's just you and
a few UFS developers using it to co-ordinate, that's perfectly fine:
you can post a summary when it's decided.  If you really want random
community people to contribute, then it should probably be an etherpad
or wiki.  Etherpads are easier because lots of people publicly host
them:

https://github.com/ether/etherpad-lite/wiki/Sites-that-run-Etherpad-Lite

Wikimedia looks to be the one least likely to vanish after use.

> The contents of that document so far is as follows:
> * Proposed date and time of the meeting.
> * Draft agenda. So far there is one item on the agenda, namely how
> to implement multiqueue support in the UFS driver without triggering
> lock contention between submitters.
> 
> PS: meeting about the UFS driver was suggested by another UFS driver 
> contributor. I try to minimize the number of meetings on my calendar.

Heh, don't we all ...

James


