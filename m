From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v13 0/9] add support for DWC UFS Controller
Date: Tue, 5 Apr 2016 10:09:13 +0100
Message-ID: <570380B9.30800@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <yq1inzxeyoe.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1inzxeyoe.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: robh@kernel.org, tomas.winkler@intel.com, vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com
List-Id: linux-scsi@vger.kernel.org

Hi,

On 4/5/2016 12:34 AM, Martin K. Petersen wrote:
>>>>>> "Joao" == Joao Pinto <Joao.Pinto@synopsys.com> writes:
> 
> Joao,
> 
> Joao> The work consisted of: - Fixed typo in ufshcd-pltfrm.c - Tweak
> Joao> ufshcd.c for UFS 2.0 support - Implement ufshcd-dwc which contains
> Joao> all DWC HW specific code - Unipro attributes were added and new
> Joao> registers were added to the driver - Implement a tc-dwc-g210
> Joao> containing G210 MPHY specific code - Implement a tc-dwc-g210 glue
> Joao> platform driver - Implement a tc-dwc-g210 glue pci driver -
> Joao> Documentation update
> 
> You really need to keep track of which Acked-by: and Reviewed-by: tags
> you have gotten from people and apply them to patches that you haven't
> changed. Otherwise we start from scratch every time you resubmit.
> 
> Thanks!
> 

It's ok to submit the same v13 with the ACK tags?

Joao
