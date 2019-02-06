From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v3 6/8] scsi: ufs: qcom: Expose the reset controller for PHY
Date: Wed, 06 Feb 2019 13:04:52 -0800
Message-ID: <154948709228.115909.11813314659494594710@swboyd.mtv.corp.google.com>
References: <20190205185902.106085-1-evgreen@chromium.org> <20190205185902.106085-7-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205185902.106085-7-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-02-05 10:59:00)
> Expose a reset controller that the phy will later use to control its
> own PHY reset in the UFS controller. This will enable the combining
> of PHY init functionality into a single function.
>=20
> Signed-off-by: Evan Green <evgreen@chromium.org>
>=20
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
