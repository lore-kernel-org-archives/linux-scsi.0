From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] ipr: fix out-of-bounds null overwrite
Date: Wed, 6 Jan 2016 05:01:47 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB445086E3@G9W0766.americas.hpqcorp.net>
References: <1452053698-75781-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:38142 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbcAFFCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 00:02:12 -0500
In-Reply-To: <1452053698-75781-1-git-send-email-wuninsu@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>, "brking@us.ibm.com" <brking@us.ibm.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "taesoo@gatech.edu" <taesoo@gatech.edu>, "yeongjin.jang@gatech.edu" <yeongjin.jang@gatech.edu>, "insu@gatech.edu" <insu@gatech.edu>, "changwoo@gatech.edu" <changwoo@gatech.edu>

> 	len = snprintf(fname, 99, "%s", buf);
> -	fname[len-1] = '\0';

Since it appears that's the only time len is actually used in that function can
you please remove the variable len completely as part of the patch?
