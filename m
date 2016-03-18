From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: select CONFIG_NLS
Date: Fri, 18 Mar 2016 15:35:42 -0400
Message-ID: <yq1mvpv8tpt.fsf@sermon.lab.mkp.net>
References: <1458217819-2802119-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458217819-2802119-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Thu, 17 Mar 2016 13:29:52 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>, James Bottomley <JBottomley@Odin.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> A recent change to ufshcd introduced a call to utf16s_to_utf8s, a
Arnd> function that is provided by the NLS module, so we get a link
Arnd> error when that is not present:

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
