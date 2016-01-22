From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [PATCH, RESEND 2] qla2xxx: Remove use of 'struct timeval'
Date: Fri, 22 Jan 2016 16:12:25 +0100
Message-ID: <1700481.AdoIR1LgPH@wuerfel>
References: <1528415.ru8bxkDU1V@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528415.ru8bxkDU1V@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Tina Ruchandani <ruchandani.tina@gmail.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Friday 22 January 2016 15:28:32 Arnd Bergmann wrote:
> struct register_host_info stores a 64-bit UTC system time timestamp.
> This patch removes the use of 'struct timeval' to obtain that timestamp
> as its tv_sec value will overflow on 32-bit systems in year 2038 beyond.
> The patch uses ktime_get_real_seconds() which returns a 64-bit seconds value.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 



I was missing

From: Tina Ruchandani <ruchandani.tina@gmail.com>

If anyone is going to pick this up, let me know whether you will fix
it up yourself or if I should resend.
