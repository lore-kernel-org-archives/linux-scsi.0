From: Olaf Hering <olaf@aepfle.de>
Subject: Re: noise in target_core_register_fabric
Date: Wed, 18 Mar 2015 08:49:47 +0100
Message-ID: <20150318074947.GA21195@aepfle.de>
References: <20150304154620.GA32023@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:31467 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbCRHtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 03:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20150304154620.GA32023@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 04, Olaf Hering wrote:

> Is there a need to fill dmesg with noise like shown below whenever
> targetcli-3.0 runs a command? I think the pr_err calls in those functions
> should be converted to pr_debug.

Any update on this?

> [ 1240.045518] target_core_register_fabric() trying autoload for fc
> [ 1240.045520] target_core_get_fabric() failed for fc

Olaf
