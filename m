From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 24/24] libsas: poll for ata device readiness after reset
Date: Mon, 19 Dec 2011 23:08:07 -0800
Message-ID: <CABE8wwvme=-xnPuREvCUu1eoATKW8uDCzPamtsZK5tsHuiAGLw@mail.gmail.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
	<20111217023512.15036.97516.stgit@localhost6.localdomain6>
	<88CA86DE150C442FA8A2CD78C7C8678D@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:48370 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047Ab1LTHIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 02:08:09 -0500
In-Reply-To: <88CA86DE150C442FA8A2CD78C7C8678D@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org

On Mon, Dec 19, 2011 at 10:18 PM, Jack Wang <jack_wang@usish.com> wrote:
> I test the patchset ,it works ok.
> You can add my tested-by if needed.
>
> Jack
>

Thank you Jack.

Very much appreciated.

I will need to refresh the patches to address Tejun's comments about
drain_workqueue(), I'll get them re-posted shortly.
