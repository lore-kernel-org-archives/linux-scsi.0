From: Cong Wang <amwang@redhat.com>
Subject: Re: [Patch] target: remove needless include of version.h
Date: Fri, 19 Aug 2011 18:01:52 +0800
Message-ID: <4E4E3490.5000404@redhat.com>
References: <1313736815-27234-1-git-send-email-amwang@redhat.com> <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1HSKZf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2011 06:25:35 -0400
In-Reply-To: <alpine.LNX.2.00.1108190906280.31857@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

=E4=BA=8E 2011=E5=B9=B408=E6=9C=8819=E6=97=A5 15:07, Jesper Juhl =E5=86=
=99=E9=81=93:
> On Fri, 19 Aug 2011, WANG Cong wrote:
>
>> They don't version.h to be compiled. Compiling tested.
>>
>
> Looks more or less identical to the patch I submitted on Aug 1 (and
> earlier) : https://lkml.org/lkml/2011/8/1/309
>
>

Ah, is your patch merged?

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
