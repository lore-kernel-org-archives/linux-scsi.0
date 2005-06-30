From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [patch 1/3] scsi/qla1280: replace schedule_timeout() with ssleep()
Date: 30 Jun 2005 05:47:54 -0400
Message-ID: <yq01x6knpkl.fsf@jaguar.mkp.net>
References: <20050620215506.376578000@nd47.coderock.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:41356 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S262908AbVF3Jr5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 05:47:57 -0400
In-Reply-To: <20050620215506.376578000@nd47.coderock.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>

>>>>> "domen" == domen  <domen@coderock.org> writes:

domen> From: Nishanth Aravamudan <nacc@us.ibm.com> Use ssleep()
domen> instead of schedule_timeout to guarantee the task delays as
domen> expected.

I don't see any problem with this.

domen> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
domen> Signed-off-by: Domen Puncer <domen@coderock.org>

Signed-off-by: Jes Sorensen <jes@trained-monkey.org>

Cheers,
Jes
