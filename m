Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91BCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE7F6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhJLRoN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbhJLRoN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 13:44:13 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31EC061570
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 10:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1634060528;
        bh=ZIBEUtRoIFIgAlM4TXhHjeJPEPLIgtX0nUc9Go5D2v4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=K5wmKQfS/iv8LUg0TEANjO3FWS7B3bzC33R8eGRx2/7OmpgrBmqfChfx/EKFbb9Sf
         KX30+8ReX8z1EK22KQq5q8ClEPp4trvZOYLlr7yQt2bV5Pw7kb2wOePRWdXVGCEZzc
         SuuNVlvynyVcor2M8lrFHLpl8tlWfwrbecEYiWtM=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 53390128063C;
        Tue, 12 Oct 2021 10:42:08 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Mb-BpwmhgOTh; Tue, 12 Oct 2021 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1634060528;
        bh=ZIBEUtRoIFIgAlM4TXhHjeJPEPLIgtX0nUc9Go5D2v4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=K5wmKQfS/iv8LUg0TEANjO3FWS7B3bzC33R8eGRx2/7OmpgrBmqfChfx/EKFbb9Sf
         KX30+8ReX8z1EK22KQq5q8ClEPp4trvZOYLlr7yQt2bV5Pw7kb2wOePRWdXVGCEZzc
         SuuNVlvynyVcor2M8lrFHLpl8tlWfwrbecEYiWtM=
Received: from jarvis.lan (c-67-166-170-96.hsd1.va.comcast.net [67.166.170.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C9EEF1280629;
        Tue, 12 Oct 2021 10:42:07 -0700 (PDT)
Message-ID: <6c9f6faf1e4a3dddbd4276402cb38318a99b6026.camel@HansenPartnership.com>
Subject: Re: Meeting about the UFS driver
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Tue, 12 Oct 2021 13:42:06 -0400
In-Reply-To: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
References: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-12 at 10:29 -0700, Bart Van Assche wrote:
> Hi,
> 
> A meeting will be held later this month to talk about the technical 
> aspects of the UFS driver and also about how to evolve the UFS
> driver further. Since using email to coordinate a date, time and
> agenda is inconvenient, please use the following document to reach
> agreement about the time of the meeting and also about the agenda:
> 
> https://docs.google.com/document/d/1pYONI__pbNcVVQqPA7iSbeQRyf0IQOuZlYR7Gnrikco/

That link is giving permission denied.  You need to update the sharing
settings to give you an access link for anyone to view.

James


