From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Wed, 20 Feb 2019 23:07:19 -0500
Message-ID: <20190221040719.GB10616@sasha-vm>
References: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com>
 <20190219121415.GA23831@kroah.com>
 <159855771db2192a00c3c248f0e3cab9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <159855771db2192a00c3c248f0e3cab9@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 19, 2019 at 07:14:17PM +0530, Sreekanth Reddy wrote:
>Greg,
>
>This patch will fix the issue discussed in below email thread,
>https://patchwork.kernel.org/patch/10734933/
>
>Yesterday same issue is been reported by Michal Soltys in below thread,
>https://marc.info/?l=linux-scsi&m=155057830803859&w=2

The log message on the patch really needs reworking: it describes what a
patch does rather than why it does it.
