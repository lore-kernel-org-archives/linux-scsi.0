From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.17-rc5-mm1
Date: Wed, 31 May 2006 00:32:47 +0200
Message-ID: <20060530223247.GB3746@elte.hu>
References: <20060530022925.8a67b613.akpm@osdl.org> <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com> <6bffcb0e0605301157o6b7c5f66q3c9f151cbb4537d5@mail.gmail.com> <20060530194259.GB22742@elte.hu> <6bffcb0e0605301457v9ba284bk75b8b6d14384489a@mail.gmail.com> <20060530220931.GA32759@elte.hu> <20060530221850.GA1764@elte.hu> <20060530222608.GA3274@elte.hu> <20060530222954.GA3746@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:1757 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S932529AbWE3Wc2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 18:32:28 -0400
Content-Disposition: inline
In-Reply-To: <20060530222954.GA3746@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> CONFIG_PROFILE_LIKELY it is, please disable it in your config, along 
> with CONFIG_DEBUG_STACKOVERFLOW:

i've also uploaded an updated tracing patch to:

  http://redhat.com/~mingo/lockdep-patches/latency-tracing-lockdep.patch

which forces CONFIG_PROFILE_LIKELY off if LATENCY_TRACE is enabled.

	Ingo
