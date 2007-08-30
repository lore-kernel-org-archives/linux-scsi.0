From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: FC - NPIV in 2.6.23-rc2
Date: Thu, 30 Aug 2007 09:47:19 -0700
Message-ID: <7579f7fb0708300947r4bae76a8j3715316741f3563f@mail.gmail.com>
References: <c7d75baf0708300849g27a5e4c3wba73b960a89a85e5@mail.gmail.com>
	 <46D6EFE7.40802@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:25408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597AbXH3QrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 12:47:20 -0400
Received: by wa-out-1112.google.com with SMTP id v27so652961wah
        for <linux-scsi@vger.kernel.org>; Thu, 30 Aug 2007 09:47:19 -0700 (PDT)
In-Reply-To: <46D6EFE7.40802@qlogic.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: Abhishek Kane <abhishek.kane@gmail.com>, linux-kernel@vger.kernel.org, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

> > some sought of documentation for this, please let me know.
> NPIV is a feature to provide multiple path available on one physical port and it has implemented based on the multiport ID (MID) capability on the switch.
> So, you have to have the switch with MID capable on the configuration to support NPIV, besides the controller.
>

No, if the switch doesn't suport NP-IV, the 24XX f/w will come up in
Public Loop mode (FL).
