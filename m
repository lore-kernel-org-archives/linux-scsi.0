From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 1/2] tests/scsi: add SCSI midlayer test group
Date: Tue, 15 Aug 2017 18:14:05 -0700
Message-ID: <20170816011405.GA6005@vader>
References: <1502275806-27972-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:38387 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdHPBOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2017 21:14:07 -0400
Received: by mail-pg0-f44.google.com with SMTP id l64so15814188pge.5
        for <linux-scsi@vger.kernel.org>; Tue, 15 Aug 2017 18:14:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1502275806-27972-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Omar Sandoval <osandov@fb.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>

On Wed, Aug 09, 2017 at 12:50:05PM +0200, Hannes Reinecke wrote:
> Add a test group for tests of the SCSI midlayer.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  tests/scsi/group | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 tests/scsi/group
> 
> diff --git a/tests/scsi/group b/tests/scsi/group
> new file mode 100644
> index 0000000..73459a6
> --- /dev/null
> +++ b/tests/scsi/group
> @@ -0,0 +1,26 @@
> +#!/bin/bash
> +#
> +# SCSI regression tests
> +#
> +# Copyright (C) 2017 Hannes Reinecke, SUSE Linux GmbH
> +#
> +# This program is free software: you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation, either version 3 of the License, or
> +# (at your option) any later version.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program.  If not, see <http://www.gnu.org/licenses/>.
> +
> +#
> +# Usually, group_requires() just needs to check that any necessary programs and
> +# kernel features are available using the _have_foo helpers. If
> +# group_requires() returns non-zero, all tests in this group will be skipped.

This comment should have been removed, looks fine otherwise.

> +group_requires() {
> +	_have_root
> +}
> -- 
> 1.8.5.6
> 
