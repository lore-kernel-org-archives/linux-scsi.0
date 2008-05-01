From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Thu, 1 May 2008 14:23:05 -0700
Message-ID: <20080501142305.77433e50.akpm@linux-foundation.org>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547AbYEAVXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 17:23:42 -0400
In-Reply-To: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com

On Thu,  1 May 2008 17:56:02 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> megaraid_sas suspend and resume are inappropriatelly placed in
> __devinit section.

That's a box-killer, isn't it?

