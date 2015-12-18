From: Martin Svec <martin.svec@zoner.cz>
Subject: Re: [PATCH 0/2] target: kthread login failure hung task + CAW
 use-after-free
Date: Fri, 18 Dec 2015 14:05:09 +0100
Message-ID: <56740484.4080206@zoner.cz>
References: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Hello Nick,

should these patches be included in 4.1.x LTS series too?:

Nicholas Bellinger (2):
  iscsi-target: Fix rx_login_comp hang after login failure
  target: Fix race for SCF_COMPARE_AND_WRITE_POST checking

They are marked as #v3.10+ and #v3.12+ but I still don't see them in 4.1.15.

Thank you,

Martin
