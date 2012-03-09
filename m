From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch] [SCSI] mvsas: remove unused variable in mvs_task_exec()
Date: Fri, 9 Mar 2012 15:50:18 -0800
Message-ID: <CAA9_cmfZ5qO1iaVpWNk=3qrkAznvQO3WhpG_-5+NdrZmHSABhw@mail.gmail.com>
References: <20120308072633.GB27713@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65469 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2CIXuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2012 18:50:20 -0500
In-Reply-To: <20120308072633.GB27713@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, James Bottomley <James.Bottomley@suse.de>, Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Mar 7, 2012 at 11:26 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We don't use "dev" any more after 07ec747a5f ("libsas: remove
> ata_port.lock management duties from lldds") and it causes a compile
> warning.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to my 'libsas' branch.  I'll carry this until James picks it up.
