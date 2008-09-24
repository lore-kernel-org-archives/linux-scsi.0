From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iscsi update for scsi-post
Date: Wed, 24 Sep 2008 11:49:11 -0500
Message-ID: <48DA6F87.6020008@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55512 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbYIXQtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:49:18 -0400
Received: from [20.15.0.9] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id m8OGnGEe004255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2008 11:49:17 -0500
In-Reply-To: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> The following patches are fixes and enhancements for 2.6.28 scsi-post,

I meant the 2.6.28 feature window. The patches are made over scsi-post 
instead of scsi-misc because of the new DID_TRANSPORT error patches,

Sorry about the bad wording.

> becuase:
> 
> Subject: [PATCH 6/7] libiscsi: check reason why we are stopping iscsi session to determine error value
> 
> collides with other patches in that tree.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

