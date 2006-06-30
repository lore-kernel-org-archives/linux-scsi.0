From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: [PATCH] aic94xx: disable split completion timer/setting by
	default
Date: Fri, 30 Jun 2006 23:24:34 +0200
Message-ID: <1151702674.11434.59.camel@laptopd505.fenrus.org>
References: <1151702230.16075.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:5303 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S932196AbWF3VYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 17:24:39 -0400
In-Reply-To: <1151702230.16075.61.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-06-30 at 14:17 -0700, Alexis Bruemmer wrote:
> The aic94xx driver will lock up under heavy load with a split completion
> error.  There is a split completion timer/setting which should be
> disabled by default but is not.  This patch fixes this problem.
> 
> Signed-off-by: Adaptec

please always put an email address in the Signed-off-by line...

