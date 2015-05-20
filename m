From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH] libsas: fix "sysfs group not found" warnings at port
 teardown time
Date: Wed, 20 May 2015 23:52:17 +0100
Message-ID: <20150520225217.GA3058@charon>
References: <20150520220858.15073.8982.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbbETWwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2015 18:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20150520220858.15073.8982.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@odin.com, hch@lst.de, Praveen Murali <pmurali@logicube.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, May 20, 2015 at 06:09:09PM -0400, Dan Williams wrote:
> Praveen reports:
>=20
> ---
>=20

Just a minor comment, not related with the patch itself but with the
commit message: the line above will cause major pain to anyone
applying this patch using 'git am'.  This is because git-mailinfo,
when splitting the patch from the message, will assume the message
stops here.

git-am(1) documents this behaviour, the commit message ends with:

- three-dashes and end-of-line, or
- a line that begins with "diff -", or
- a line that begins with "Index: "

Cheers,
--
Lu=EDs

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
