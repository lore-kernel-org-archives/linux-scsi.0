From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.19 009/118] scsi: ufs: Fix hynix ufs bug with quirk on
 hi36xx SoC
Date: Mon, 17 Dec 2018 09:30:02 +0100
Message-ID: <20181217083002.GA5244@kroah.com>
References: <20181211151644.216668863@linuxfoundation.org>
 <20181211151644.599741132@linuxfoundation.org>
 <CAP2JTQJyOad9Tbc8t_K-Xp8q5EpdgeQbaDfTAJgkYUWWpw=TRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAP2JTQJyOad9Tbc8t_K-Xp8q5EpdgeQbaDfTAJgkYUWWpw=TRg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Kyuho Choi <chlrbgh0@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Wei Li <liwei213@huawei.com>, Dmitry Shmidt <dimitrysh@google.com>, John Stultz <john.stultz@linaro.org>, Sasha Levin <sashal@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 17, 2018 at 05:24:38PM +0900, Kyuho Choi wrote:
> Hi Greg,
> 
> About Hinyx's "hB8aL1" ufs device. For support Kirin AP series, they
> are need to apply below VS_DebugSaveConfigTime expand patch.

I am sorry, I do not understand at all.  What needs to be done on the
4.19.y stable tree?  Is a specific patch needed that is already in
Linus's tree?  If so, what is the git commit id?

thanks,

greg k-h
