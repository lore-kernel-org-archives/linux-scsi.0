From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 0/9] add support for DWC UFS Controller
Date: Mon, 04 Apr 2016 19:34:09 -0400
Message-ID: <yq1inzxeyoe.fsf@sermon.lab.mkp.net>
References: <cover.1459448160.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com> (Joao Pinto's message
	of "Mon, 4 Apr 2016 12:13:24 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: robh@kernel.org, tomas.winkler@intel.com, martin.petersen@oracle.com, vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Joao" == Joao Pinto <Joao.Pinto@synopsys.com> writes:

Joao,

Joao> The work consisted of: - Fixed typo in ufshcd-pltfrm.c - Tweak
Joao> ufshcd.c for UFS 2.0 support - Implement ufshcd-dwc which contains
Joao> all DWC HW specific code - Unipro attributes were added and new
Joao> registers were added to the driver - Implement a tc-dwc-g210
Joao> containing G210 MPHY specific code - Implement a tc-dwc-g210 glue
Joao> platform driver - Implement a tc-dwc-g210 glue pci driver -
Joao> Documentation update

You really need to keep track of which Acked-by: and Reviewed-by: tags
you have gotten from people and apply them to patches that you haven't
changed. Otherwise we start from scratch every time you resubmit.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
