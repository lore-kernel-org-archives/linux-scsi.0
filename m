From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Fri, 07 Jun 2019 03:41:29 +0300
Message-ID: <1559868089.3233.1.camel@linux.ibm.com>
References: <1559833471-30534-1-git-send-email-info@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559833471-30534-1-git-send-email-info@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <info@metux.net>, linux-kernel@vger.kernel.org
Cc: khalid@gonehiking.org, martin.petersen@oracle.com, aacraid@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-06-06 at 17:04 +0200, Enrico Weigelt, metux IT consult
wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
> so the extra check here is not necessary.
> 
> Changes v2:
>     * make dptids const to fix warning on unused variable

I don't think this works; in my version of gcc, const does not defeat
the unused variable warning if I try with a test programme:

jejb@jarvis:~> gcc -Wunused-variable -c test1.c
test1.c:3:18: warning: ‘i’ defined but not used [-Wunused-cons
t-variable=]
 static const int i[] = { 1, 2, 3};

James
