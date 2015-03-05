From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: noise in target_core_register_fabric
Date: Wed, 04 Mar 2015 19:57:29 -0800
Message-ID: <1425527849.925.8.camel@haakon3.risingtidesystems.com>
References: <20150304154620.GA32023@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48389 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbCED5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 22:57:30 -0500
In-Reply-To: <20150304154620.GA32023@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2015-03-04 at 16:46 +0100, Olaf Hering wrote:
> Is there a need to fill dmesg with noise like shown below whenever
> targetcli-3.0 runs a command? I think the pr_err calls in those functions
> should be converted to pr_debug.
> 

Fair enough.  Care to send out a patch for this..?  ;)

--nab

