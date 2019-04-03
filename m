From: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: scsi: ufs-cdns: Update Cadence UFS
 compatibility list
Date: Tue, 2 Apr 2019 23:15:42 -0500
Message-ID: <CAL_JsqKBU92j_MCZ21TSD7=f-zu4+pF91u1uoZY+=d+jOeQb0A@mail.gmail.com>
References: <20190327144405.5716-1-jank@cadence.com> <20190327144405.5716-2-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327144405.5716-2-jank@cadence.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kotas <jank@cadence.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, pedrom.sousa@synopsys.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, devicetree@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 27, 2019 at 9:45 AM Jan Kotas <jank@cadence.com> wrote:
>
> This patch adds a new compatible string description for
> CDNS UFS HCD + M31 16nm PHY.
>
> Signed-off-by: Jan Kotas <jank@cadence.com>
> ---
>  Documentation/devicetree/bindings/ufs/cdns,ufshc.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
