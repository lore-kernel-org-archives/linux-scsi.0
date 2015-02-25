From: Bjorn Andersson <bjorn@kryo.se>
Subject: Re: [PATCH 0/5] Rename regulator_set_optimum_mode
Date: Wed, 25 Feb 2015 15:40:31 -0800
Message-ID: <CAJAp7Oi67uuLEsXZbfo68zVa1XTOVhr7Q+V6n7QKC7rnQTywyA@mail.gmail.com>
References: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40212 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbBYXkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 18:40:33 -0500
Received: by lbdu10 with SMTP id u10so7393622lbd.7
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2015 15:40:32 -0800 (PST)
In-Reply-To: <1423712131-23795-1-git-send-email-bjorn.andersson@sonymobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, Feb 11, 2015 at 7:35 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> Changing the name of the regulator_set_optimum_mode() to
> regulator_set_load() better reflects that the API is doing.
>

Any comments on this?

I'm going to propose a patch to the mmc framework calling this api, so
it would be good to know before I add another consumer of the api.

Regards,
Bjorn
