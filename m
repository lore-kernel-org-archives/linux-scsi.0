Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="XOPpQnjL"
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933D21727;
	Fri,  8 Dec 2023 02:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1702033036; bh=wmXqZI+htGE1dnL/ugcu544cOcD3OgDElvjhq2vbEJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XOPpQnjLMEnV6UnmvW0WxrIOxNt54pI7xSn4dn9mkEBag+hBDNTWKC1GihhzZ5YWC
	 NqInASJj58LVLNEx53ny2KVLjBuaX5Ph6oe1qa7mIhkuNqXIMkeELE8cBkXrLitrQz
	 7C7lD8GWEV1AVjcMxEnaJPg7fwrLxxLnhIwnEM68=
Date: Fri, 8 Dec 2023 11:57:16 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, mani@kernel.org, 
	quic_cang@quicinc.com, quic_asutoshd@quicinc.com, beanhuo@micron.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikebi@micron.com, 
	lporzio@micron.com
Subject: Re: [PATCH v4 0/3] Add UFS RTC support
Message-ID: <1010da2a-b4bc-477f-8835-c342de0accca@t-8ch.de>
References: <20231208103940.153734-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231208103940.153734-1-beanhuo@iokpp.de>

On 2023-12-08 11:39:37+0100, Bean Huo wrote:
> [..]

> Bean Huo (3):
>   scsi: ufs: core: Add ufshcd_is_ufs_dev_busy()
>   scsi: ufs: core: Add UFS RTC support
>   scsi: ufs: core: Add sysfs node for UFS RTC update
> 
>  Documentation/ABI/testing/sysfs-driver-ufs |   7 ++
>  drivers/ufs/core/ufs-sysfs.c               |  31 +++++++
>  drivers/ufs/core/ufshcd.c                  | 103 ++++++++++++++++++++-
>  include/ufs/ufs.h                          |  15 +++
>  include/ufs/ufshcd.h                       |   4 +
>  5 files changed, 156 insertions(+), 4 deletions(-)

For the full series:

Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
