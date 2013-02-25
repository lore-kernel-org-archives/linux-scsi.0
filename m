From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: [LSF/MM TOPIC] Making sure soft SCSI Targets are Valid
Date: Mon, 25 Feb 2013 09:19:15 -0800
Message-ID: <CAN05THS0VdznK8N3A-jR6yBP+JGcDmud1YohXwKqV9czdba+NA@mail.gmail.com>
References: <51081F68.1030808@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47547 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3BYRTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 12:19:16 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm14so3508884wib.10
        for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2013 09:19:15 -0800 (PST)
In-Reply-To: <51081F68.1030808@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org

Hi,

This is my attend request to to co-present a paper with Lee Duncan.

regards
ronnie sahlberg

On Tue, Jan 29, 2013 at 11:13 AM, Lee Duncan <lduncan@suse.com> wrote:
> Hi:
>
> I'm not sure if there is much interest in this, but I've recently
> realized that there is no good free software to validate iSCSI targets,
> not to mention FCOE targets, IB soft targets, etc. There's just no way
> to know if any change you make is "legal" short of learning to speak
> SCSI geek spec (or waiting to see what fails when you make a subtle change).
>
> So I have been working with the (user-space) libiscsi creator and
> maintainer, Ronnie Sahlberg, to enhance his test suite. But this only
> addresses iSCSI targets. Some of his tests have already shown problems
> like kernel panics when an incorrect bit is injected, showing the need
> for such testing.
>
> It occurs to me it would be most valuable if we had more generic SCSI
> tests, not even limited to soft targets, available to developers and
> manufacturers. How best to support such tests with our SCSI layer, and
> what tests are needed now and in the future may be a good topic for
> discussion.
> --
> Lee Duncan
> SUSE Labs
