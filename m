From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] aic79xx should be able to ignore HostRAID enabled
	adapters
Date: Thu, 01 Dec 2005 09:08:01 +0100
Message-ID: <1133424481.2853.10.camel@laptopd505.fenrus.org>
References: <438E90DD.3010007@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38306 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750775AbVLAIIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 03:08:05 -0500
In-Reply-To: <438E90DD.3010007@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Chris McDermott <lcm@us.ibm.com>, Luvella McFadden <luvella@us.ibm.com>, AJ Johnson <blujuice@us.ibm.com>, Kevin Stansell <kstansel@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>   Upon bootup, the aic79xx
> driver will grab both controllers even though I'd prefer that Adaptec's a320raid
> driver grab the HostRAID controller.  

where is the sourcecode for the a320raid driver?

afaik dmraid supports this format already, and if not I would urge you
to help the dmraid project to support it instead..


