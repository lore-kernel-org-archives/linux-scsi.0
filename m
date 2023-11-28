Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3C46421;
	Tue, 28 Nov 2023 11:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jH8rMrpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB088C433C9;
	Tue, 28 Nov 2023 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701169429;
	bh=RuN83uZU0ViigSxLsl1fezUOYA7OPMFJtWAUwKSFmMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jH8rMrpuKeWkEUFmqohSTh/33Dmmf9PKYbItvO4e87DYJ/MZ7sD/sLQBK0awgxdg9
	 4BBIOaP5zk1wTZ54/hVu5xswTa7sQGtwmA4ru7dpQwqF1t0FB+XROrZ4xZBpwMpXIk
	 Tc/rsf2tP3Wsaye/sCCFJ+XJk4UBYiKv5l1xFszFGGNdmMu+z1syVm8NH1Dyr1GABs
	 Hko8L74saFFbJHkeJtDWygxL8UQxpUGY8vjpUuVbthG/7DRxcPbo6r99QDzHknyLqa
	 LOPeku8nr1gAOTz2mRhez+5UvfDOZRlU5ZI9F5YujbCDUCNrCDwWOY//llpbzrd7hk
	 UtLfeziz9CXhQ==
Date: Tue, 28 Nov 2023 16:33:38 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_asutoshd@quicinc.com, quic_cang@quicinc.com, bvanassche@acm.org,
	stanley.chu@mediatek.com, adrian.hunter@intel.com,
	beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
	martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
	quic_nitirawa@quicinc.com, linux-scsi@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] dt-bindings: ufs: Add msi-parent for UFS MCQ
Message-ID: <20231128110338.GQ3088@thinkpad>
References: <1701144469-1018-1-git-send-email-quic_ziqichen@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1701144469-1018-1-git-send-email-quic_ziqichen@quicinc.com>

On Tue, Nov 28, 2023 at 12:07:47PM +0800, Ziqi Chen wrote:
> The Message Signaled Interrupts (MSI) support has been introduced in
> UFSHCI version 4.0 (JESD223E). The MSI is the recommended interrupt
> approach for MCQ. If choose to use MSI, In UFS DT, we need to provide
> msi-parent property that point to the hardware entity which serves as
> the MSI controller for this UFS controller.
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
> V3 -> V4: Corrected version change format.
> V2 -> V3: Wrap commit message to meet Linux coding style.
> V1 -> V2: Rebased on Linux 6.7-rc1 and updated the commit message to
>           incorporate the details about when MCQ/MSI got introduced.
> ---
>  Documentation/devicetree/bindings/ufs/ufs-common.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-common.yaml b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> index 985ea8f..31fe7f3 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> +++ b/Documentation/devicetree/bindings/ufs/ufs-common.yaml
> @@ -87,6 +87,8 @@ properties:
>      description:
>        Specifies max. load that can be drawn from VCCQ2 supply.
>  
> +  msi-parent: true
> +
>  dependencies:
>    freq-table-hz: [ clocks ]
>    operating-points-v2: [ clocks, clock-names ]
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
