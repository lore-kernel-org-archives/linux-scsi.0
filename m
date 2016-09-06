From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/3] documentation/scsi: Remove nodisconnect parameter
Date: Tue, 6 Sep 2016 06:41:26 -0600
Message-ID: <20160906064126.0de3aa3c@lwn.net>
References: <20160827022958.983743612@telegraphics.com.au>
        <20160827022959.119870978@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160827022959.119870978@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 27 Aug 2016 12:29:59 +1000
Finn Thain <fthain@telegraphics.com.au> wrote:

> The driver that used the 'nodisconnect' parameter was removed in
> commit 565bae6a4a8f ("[SCSI] 53c7xx: kill driver"). Related documentation
> was cleaned up in commit f37a7238d379 ("[SCSI] 53c7xx: fix removal
> fallout"), except for the remaining two mentions that are removed here.

Applied to the docs tree, thanks.

jon
