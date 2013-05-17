From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH 1/3] BusLogic: Add __printf verification, fix fallout
Date: Fri, 17 May 2013 14:18:37 -0600
Message-ID: <1368821917.24376.1.camel@concerto>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <0424edbf1b8d1c432565ff5315d5c694a416fe0e.1368765873.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0424edbf1b8d1c432565ff5315d5c694a416fe0e.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Make format and arguments match.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 50 ++++++++++++++++++++++++-------------------------
>  drivers/scsi/BusLogic.h |  1 +
>  2 files changed, 26 insertions(+), 25 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
