From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] gdth: Fixup section annotations
Date: Fri, 10 Jan 2014 17:07:24 +0000
Message-ID: <1389373643.4066.0.camel@dabdike>
References: <1389367888-117607-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:42122 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaAJRH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 12:07:27 -0500
In-Reply-To: <1389367888-117607-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <73B5BA4F53730D4DA865D238C35892E1@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2014-01-10 at 16:31 +0100, Hannes Reinecke wrote:
> Fixup section annotations so that kbuild doesn't complain anymore.

This doesn't look right: __devinit is now an obsolete annotation.

James

