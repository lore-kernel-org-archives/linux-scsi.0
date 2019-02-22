From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH v4 7/8] phy: qcom: Utilize UFS reset controller
Date: Fri, 22 Feb 2019 12:28:18 -0800
Message-ID: <155086729867.77512.8850537052264643664@swboyd.mtv.corp.google.com>
References: <20190213232526.26995-1-evgreen@chromium.org> <20190213232526.26995-8-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213232526.26995-8-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Gross <andy.gross@linaro.org>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-kernel@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Quoting Evan Green (2019-02-13 15:25:25)
> Move the PHY reset from ufs-qcom into the respective PHYs. This will
> allow us to merge the two phases of UFS PHY initialization.
>=20
> Signed-off-by: Evan Green <evgreen@chromium.org>
>=20
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
