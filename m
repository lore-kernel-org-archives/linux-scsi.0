From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: kthread login failure hung task + CAW
 use-after-free
Date: Sun, 20 Dec 2015 23:19:19 -0800
Message-ID: <1450682359.25674.49.camel@haakon3.risingtidesystems.com>
References: <1447546903-15305-1-git-send-email-nab@daterainc.com>
	 <56740484.4080206@zoner.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56740484.4080206@zoner.cz>
Sender: target-devel-owner@vger.kernel.org
To: Martin Svec <martin.svec@zoner.cz>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-12-18 at 14:05 +0100, Martin Svec wrote:
> Hello Nick,
> 
> should these patches be included in 4.1.x LTS series too?:
> 
> Nicholas Bellinger (2):
>   iscsi-target: Fix rx_login_comp hang after login failure
>   target: Fix race for SCF_COMPARE_AND_WRITE_POST checking
> 
> They are marked as #v3.10+ and #v3.12+ but I still don't see them in 4.1.15.
> 

FYI, Kamal has applied both to v3.19.y + v3.13.y stable code.

Me thinks Greg-KH stable backlog is higher than usual due to holidays,
etc.  I'm sure he will be getting back to it soon.  ;)

--nab
