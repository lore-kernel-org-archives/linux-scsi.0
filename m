From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH for-next] scsi: ufs: Update dwc driver maintainer to
 Pedro Sousa
Date: Wed, 30 Jan 2019 09:54:08 -0800
Message-ID: <1548870848.213038.3.camel@acm.org>
References: <812e9e1426555808ad1bd5fbfda320c6684abc81.1548869844.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <812e9e1426555808ad1bd5fbfda320c6684abc81.1548869844.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <joao.pinto@synopsys.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pedrom.sousa@synopsys.com, marc.w.gonzalez@free.fr, Alex.Lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-01-30 at 18:48 +-0100, Joao Pinto wrote:
+AD4 Currently I am managing the Synopsys drivers +ACY tools team (full-time) and
+AD4 so I am passing the DWC UFS driver maintenance to Pedro Sousa.
+AD4 
+AD4 Signed-off-by: Joao Pinto +ADw-jpinto+AEA-synopsys.com+AD4
+AD4 Cc: Pedro Sousa +ADw-pedrom.sousa+AEA-synopsys.com+AD4
+AD4 Cc: Marc Gonzalez +ADw-marc.w.gonzalez+AEA-free.fr+AD4
+AD4 Cc: Alex Lemberg +ADw-Alex.Lemberg+AEA-wdc.com+AD4
+AD4 ---
+AD4  MAINTAINERS +AHw 2 +--
+AD4  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4 
+AD4 diff --git a/MAINTAINERS b/MAINTAINERS
+AD4 index 70c93b1..458a2a2 100644
+AD4 --- a/MAINTAINERS
+AD4 +-+-+- b/MAINTAINERS
+AD4 +AEAAQA -15673,7 +-15673,7 +AEAAQA F:	Documentation/scsi/ufs.txt
+AD4  F:	drivers/scsi/ufs/
+AD4  
+AD4  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
+AD4 -M:	Joao Pinto +ADw-jpinto+AEA-synopsys.com+AD4
+AD4 +-M:	Pedro Sousa +ADw-pedrom.sousa+AEA-synopsys.com+AD4
+AD4  L:	linux-scsi+AEA-vger.kernel.org
+AD4  S:	Supported
+AD4  F:	drivers/scsi/ufs/+ACo-dwc+ACo

Shouldn't people have proven to be willing to stick around before being
added as a kernel maintainer? Additionally, what is the experience level of
Pedro with kernel development? All I know is the following:

+ACQ git log --author +ACI-Pedro Sousa+ACI +AHw wc -l
0
+ACQ git log +AHw grep -c +ACI-Pedro Sousa+ACI
0

Are you aware that people who are not mentioned in the MAINTAINERS file are
allowed to review kernel patches?

Thanks,

Bart.
