From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: bfa: Avoid implicit enum conversion in bfad_im_post_vendor_event
Date: Tue, 16 Oct 2018 21:45:42 -0400
Message-ID: <yq1a7ndpcqh.fsf@oracle.com>
References: <20180926045435.9213-1-natechancellor@gmail.com>
        <20180927235651.27151-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927235651.27151-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 27 Sep 2018 16:56:52 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns when one enumerated type is implicitly converted to another.
>
> drivers/scsi/bfa/bfa_fcs_lport.c:379:26: warning: implicit conversion
> from enumeration type 'enum bfa_lport_aen_event' to different
> enumeration type 'enum bfa_ioc_aen_event' [-Wenum-conversion]
>                                   BFA_AEN_CAT_LPORT, event);
>                                                      ^~~~~

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
