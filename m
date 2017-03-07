From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: replace init_timer by setup_timer
Date: Mon, 06 Mar 2017 22:49:25 -0500
Message-ID: <yq1h935kapm.fsf@oracle.com>
References: <20170303124548.30176-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170303124548.30176-1-jslaby@suse.cz> (Jiri Slaby's message of
        "Fri, 3 Mar 2017 13:45:48 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: james.smart@broadcom.com, linux-kernel@vger.kernel.org, Tomas Jasek <tomsik68@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jiri" == Jiri Slaby <jslaby@suse.cz> writes:

Jiri> From: Tomas Jasek <tomsik68@gmail.com> This patch shortens every
Jiri> init_timer in lpfc module followed by function and data assignment
Jiri> using setup_timer.  This is purely cleanup patch, it does not add
Jiri> new functionality nor remove any existing functionality.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
